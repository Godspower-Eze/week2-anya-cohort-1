//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract StakingRewards is OwnableUpgradeable, ReentrancyGuardUpgradeable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public stakingToken;
    IERC20 public rewardToken;

    uint256 public rewardRate; // Token given per second
    uint256 public lastUpdateTime; // Tracks the time of last update
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) userRewardPerTokenPaid;
    mapping(address => uint256) rewards;

    uint256 private totalSupply; // Total staked token
    mapping(address => uint256) private balances; // Number of token staked per user

    function initialize(
        address _stakingToken,
        address _rewardToken,
        uint256 _rewardRate
    ) external initializer {
        __Ownable_init();
        __ReentrancyGuard_init();
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        rewardRate = _rewardRate;
    }

    /**
        @dev reward per token at any given time and this is calculated as follows:
        rewardRate * (block.timestamp - lastUpdateTime) * 1e18 / totalSupply
     */
    function rewardPerToken() public view returns (uint256) {
        if (totalSupply == 0) {
            return 0;
        }
        return (
            rewardRate.mul(block.timestamp.sub(lastUpdateTime)).mul(1e18).div(
                totalSupply
            )
        );
    }

    /**
        @dev computes reward a user has earned so far and it is calculated as follows:
        (balances[user] * (rewardPerToken() - userRewardPerTokenPaid[_user]) / 1e18) + rewards[_user].

        Basically, this multiplies the user's stake by the subtraction of the user's reward per token from
        the reward per token then divides by 1e18 because we have multiplied it by it previously. Then, adds to the
        already existing rewards.
     */
    function earned(address _user) public view returns (uint256) {
        return
            (
                balances[_user]
                    .mul(rewardPerToken().sub(userRewardPerTokenPaid[_user]))
                    .div(1e18)
            ).div(rewards[_user]);
    }

    function updateReward(address _user) internal {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        rewards[_user] = earned(_user);
        userRewardPerTokenPaid[_user] = rewardPerTokenStored;
    }

    function stake(uint256 _amount) external nonReentrant {
        updateReward(msg.sender);
        require(_amount > 0, "Cannot stake 0");
        totalSupply = totalSupply.add(_amount);
        balances[msg.sender] += _amount;
        stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _amount) external nonReentrant {
        updateReward(msg.sender);
        require(_amount > 0, "Cannot stake 0");
        totalSupply = totalSupply.sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        stakingToken.safeTransfer(msg.sender, _amount);
    }

    function getRewards() external nonReentrant {
        updateReward(msg.sender);
        uint256 _reward = rewards[msg.sender];
        if (_reward > 0) {
            rewards[msg.sender] = 0;
            rewardToken.safeTransfer(msg.sender, _reward);
        }
    }
}
