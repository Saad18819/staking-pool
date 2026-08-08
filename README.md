# ⚡ Time-Locked Staking Pool with Daily Linear Vesting

A production-grade, decentralized Ethereum staking pool built using **Solidity v0.8.19** and **Foundry**. 

This contract allows users to stake ETH, enforces a minimum USD deposit threshold via **Chainlink Price Feeds**, and applies a **daily linear vesting model** with penalty logic for early withdrawals over a 7-day target duration.

---

## 📌 Features & Architecture

* **Chainlink Oracle Integration:** Uses Chainlink `AggregatorV3Interface` to fetch real-time ETH/USD prices and enforce a minimum deposit threshold dynamically.
* **Daily Linear Vesting Schedule:**
  * **Day 0:** Instant exit allowed; returns **100% principal** (0% bonus, 0% penalty on principal).
  * **Days 1–6:** Partial daily bonus accrual with linear early-withdrawal penalties.
  * **Day 7+:** Reaches maximum **10% bonus cap** on staked capital.
* **Security & Reentrancy Guards:** Strictly adheres to the **Checks-Effects-Interactions (CEI)** pattern by clearing all internal mappings (`stakersAmnt`, `deposited`, `depositTime`) *before* executing external ETH calls.
* **Custom Errors:** Optimized gas efficiency by using custom errors (`NotEnoughAmnt()`, `NoDoublePayment()`) instead of heavy require strings.

---

## 📐 Mathematical Model

### 1. Chainlink Price Scaling
Chainlink ETH/USD feeds return prices with **8 decimal places**. To normalize to standard Ethereum 18-decimal precision (`1e18`), prices are scaled by $10^{10}$:

$$\text{Scaled Price} = \text{Chainlink Price} \times 10^{10}$$

$$\text{USD Value} = \frac{\text{Scaled Price} \times \text{ETH Amount}}{10^{18}}$$

### 2. Time Vesting & Penalty Formula
Let $P$ be the Principal ETH deposited, $D$ be the full days elapsed ($\lfloor\text{timeElapsed} / 86400\rfloor$), and $B$ be the base 10% bonus ($0.10 \times P$).

$$\text{Fine} = (7 - D) \times 10\% \times B$$

$$\text{Net Payout} = P + B - \text{Fine}$$

* **Day 0 ($D = 0$):** $\text{Payout} = P$
* **Day 3 ($D = 3$):** $\text{Fine} = 4 \times 10\% \times B = 40\% \text{ of Bonus} \implies \text{Payout} = P + 0.60 B$
* **Day 7 ($D \ge 7$):** $\text{Fine} = 0 \implies \text{Payout} = P + B$

---

## 📂 Project Structure

```text
├── script/
│   └── DeployStakingPool.s.sol   # Foundry broadcast script
├── src/
│   └── StakingPool.sol           # Core Staking & Vesting contract
├── test/
│   └── StakingTest.t.sol         # Comprehensive unit suite (vm.warp, hoax)
├── foundry.toml                  # Foundry configuration & remappings
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
* [Foundry](https://getfoundry.sh/) (`forge`, `cast`, `anvil`)
* Git

### Installation
1. Clone the repository:
   ```bash
   git clone [https://github.com/YOUR_USERNAME/staking-pool-foundry.git](https://github.com/YOUR_USERNAME/staking-pool-foundry.git)
   cd staking-pool-foundry
   ```

2. Install dependencies (Chainlink Brownie Contracts & Forge Std):
   ```bash
   forge install smartcontractkit/chainlink-brownie-contracts@1.3.0 --no-commit
   forge install foundry-rs/forge-std --no-commit
   ```

3. Build the project:
   ```bash
   forge build
   ```

---

## 🧪 Testing Strategy

The test suite covers full deposit validation, reentrancy guards, and time-warped state verification across all vesting milestones using **Mainnet Forking**.

### Run Unit Tests
To test against the live Chainlink Mainnet feed:

```bash
forge test --fork-url <YOUR_MAINNET_RPC_URL> -vvv
```

### Key Test Coverage
* `testfund()`: Verifies successful deposits above minimum USD threshold.
* `testDayZeroWithdraw()`: Confirms exact principal return when withdrawing immediately.
* `testDayThreeWithdraw()`: Uses `vm.warp(block.timestamp + 3 days)` to assert exact partial bonus math ($P + 0.6 B$).
* `testDaySevenWithdraw()`: Uses `vm.warp(block.timestamp + 7 days)` to verify full 10% bonus unlocked.

---

## 📄 License
This project is licensed under the **MIT License**.
