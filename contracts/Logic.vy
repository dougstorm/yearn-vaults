# @version 0.2.15
"""
@title Yearn Token Logic Stateless
@license GNU AGPLv3
@author yearn.finance
@notice
    For further details, please refer to the specification:
    https://github.com/iearn-finance/yearn-vaults/blob/master/SPECIFICATION.md
"""

API_VERSION: constant(String[28]) = "0.5.1"

# TODO: has interface to Vault
# Only vault can access contract operations
interface VaultAPI:
    def apiVersion() -> String[28] : view

interface CustomHealthCheck:
    def check(profit: uint256, loss: uint256, callerStrategy: address) -> bool: view

vault:  public(address)
initalized: bool

struct StrategyParams:
    performanceFee: uint256  # Strategist's fee (basis points)
    activation: uint256  # Activation block.timestamp
    debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
    minDebtPerHarvest: uint256  # Lower limit on the increase of debt since last harvest
    maxDebtPerHarvest: uint256  # Upper limit on the increase of debt since last harvest
    lastReport: uint256  # block.timestamp of the last time a report occured
    totalDebt: uint256  # Total outstanding debt that Strategy has
    totalGain: uint256  # Total returns that Strategy has realized for Vault
    totalLoss: uint256  # Total losses that Strategy has realized for Vault
    enforceChangeLimit: bool # Allow bypassing the lossRatioLimit checks
    profitLimitRatio: uint256 # Allowed Percentage of price per share positive changes
    lossLimitRatio: uint256 # Allowed Percentage of price per share negative changes
    customCheck: address

# Logic contract meant to be stateless as much as possible and headless
# only responds to vault commands and operations

@external
def __init__(vault: address):
    self.vault = vault

@external
def setup():
    assert msg.sender == self.vault
    # NOTE: not sure this is needed for security measures if we make all access
    # restricted to only vault
    self.initalized == True
    # do more setup needed here


