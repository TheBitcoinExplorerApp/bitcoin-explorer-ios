//
//  JSONFixtures.swift
//  BitcoinBlockExplorerUnitTests
//
//  Canned JSON payloads modelled on the real responses from mempool.space and
//  blockchain.info. Centralising them keeps the model-decoding tests and the
//  ViewModel network tests in sync with a single source of truth.
//

import Foundation

enum JSONFixtures {

    static func data(_ string: String) -> Data { Data(string.utf8) }

    // MARK: - Prices

    /// `GET https://mempool.space/api/v1/prices`
    static let coins = """
    {
        "time": 1700000000,
        "USD": 65000.5,
        "EUR": 60000.25,
        "GBP": 51000.0,
        "CAD": 88000.0,
        "CHF": 57000.0,
        "AUD": 99000.0,
        "JPY": 9500000.0
    }
    """

    /// `GET https://blockchain.info/ticker`
    static let coins2 = """
    {
        "BRL": { "15m": 350000.0, "last": 350000.0, "buy": 350000.0, "sell": 350000.0, "symbol": "R$" },
        "CNY": { "15m": 470000.0, "last": 470000.0, "buy": 470000.0, "sell": 470000.0, "symbol": "¥" },
        "RUB": { "15m": 6000000.0, "last": 6000000.0, "buy": 6000000.0, "sell": 6000000.0, "symbol": "RUB" }
    }
    """

    // MARK: - Fees

    /// `GET https://mempool.space/api/v1/fees/recommended`
    static let fees = """
    {
        "fastestFee": 25,
        "halfHourFee": 18,
        "hourFee": 12,
        "economyFee": 8,
        "minimumFee": 1
    }
    """

    // MARK: - Mempool

    /// `GET https://mempool.space/api/mempool`
    static let mempool = """
    {
        "count": 12345,
        "vsize": 9876543,
        "total_fee": 4567890.0
    }
    """

    /// `GET https://mempool.space/api/v1/fees/mempool-blocks`
    static let mempoolSize = """
    [
        { "blockSize": 1500000.0, "blockVSize": 1000000.0, "nTx": 2500 },
        { "blockSize": 1400000.0, "blockVSize": 999000.0, "nTx": 2400 },
        { "blockSize": 1300000.0, "blockVSize": 500000.0, "nTx": 1200 }
    ]
    """

    // MARK: - Blocks

    /// One element of `GET https://mempool.space/api/v1/blocks/`
    static let blockHeader = """
    [
        {
            "id": "0000000000000000000146f86d5e84a3f23a5d63f0a3c2c6dc6f9c2b6e8e3f3a",
            "height": 840000,
            "size": 1571.0,
            "tx_count": 3050,
            "timestamp": 1713571767,
            "extras": {
                "medianFee": 121.5,
                "pool": { "name": "Foundry USA" }
            }
        },
        {
            "id": "00000000000000000002a7c4c1e48d76c5a37902165a270156b7a8d72728a054",
            "height": 839999,
            "size": 1650.0,
            "tx_count": 4001,
            "timestamp": 1713571000,
            "extras": {
                "medianFee": 99.0,
                "pool": { "name": "AntPool" }
            }
        }
    ]
    """

    /// `GET https://mempool.space/api/block/{hash}` -> single block height
    static let blockSearchByHash = """
    { "height": 840000 }
    """

    // MARK: - Transactions

    /// A single confirmed transaction (`GET .../api/tx/{txid}`).
    static let transaction = """
    {
        "txid": "9a1c3e7b5d2f4a8c6e0b1d3f5a7c9e1b3d5f7a9c1e3b5d7f9a1c3e5b7d9f1a3c",
        "size": 226,
        "fee": 4520.0,
        "vin": [
            {
                "prevout": {
                    "scriptpubkey_address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
                    "value": 150000.0
                }
            }
        ],
        "vout": [
            {
                "scriptpubkey_address": "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa",
                "value": 100000.0
            },
            {
                "scriptpubkey_address": null,
                "value": 45480.0
            }
        ],
        "status": {
            "confirmed": true,
            "block_height": 839900,
            "block_hash": "00000000000000000002a7c4c1e48d76c5a37902165a270156b7a8d72728a054",
            "block_time": 1713560000
        }
    }
    """

    /// A list of transactions, with a coinbase tx (no prevout) first.
    static let blockTransactions = """
    [
        {
            "txid": "coinbase00000000000000000000000000000000000000000000000000000000",
            "size": 200,
            "fee": 0.0,
            "vin": [ { "prevout": null } ],
            "vout": [ { "scriptpubkey_address": "bc1qcoinbaseaddrxxxxxxxxxxxxxxxxxxxxxxxxxx", "value": 312500000.0 } ],
            "status": { "confirmed": true, "block_height": 840000, "block_hash": "abc", "block_time": 1713571767 }
        },
        {
            "txid": "feeded00000000000000000000000000000000000000000000000000000000aa",
            "size": 250,
            "fee": 3000.0,
            "vin": [ { "prevout": { "scriptpubkey_address": "1BoatSLRHtKNngkdXEeobR76b53LETtpyT", "value": 500000.0 } } ],
            "vout": [ { "scriptpubkey_address": "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy", "value": 497000.0 } ],
            "status": { "confirmed": false, "block_height": null, "block_hash": null, "block_time": null }
        }
    ]
    """

    /// An unconfirmed transaction (pending in mempool).
    static let unconfirmedTransaction = """
    {
        "txid": "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
        "size": 140,
        "fee": 1200.0,
        "vin": [ { "prevout": { "scriptpubkey_address": "bc1qpendingaddrxxxxxxxxxxxxxxxxxxxxxxxxxxx", "value": 60000.0 } } ],
        "vout": [ { "scriptpubkey_address": "bc1qoutaddrxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "value": 58800.0 } ],
        "status": { "confirmed": false, "block_height": null, "block_hash": null, "block_time": null }
    }
    """

    // MARK: - Address

    /// `GET https://mempool.space/api/address/{address}`
    static let addressHeader = """
    {
        "address": "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa",
        "chain_stats": {
            "funded_txo_count": 10,
            "funded_txo_sum": 5000000000.0,
            "spent_txo_count": 4,
            "spent_txo_sum": 3000000000.0,
            "tx_count": 14
        },
        "mempool_stats": {
            "funded_txo_count": 0,
            "funded_txo_sum": 0.0,
            "spent_txo_count": 0,
            "spent_txo_sum": 0.0,
            "tx_count": 0
        }
    }
    """

    // MARK: - Network stats

    /// `GET https://bitnodes.io/api/v1/snapshots/`
    static let fullNodes = """
    {
        "count": 1,
        "results": [
            { "timestamp": 1713571767, "total_nodes": 18500, "latest_height": 840000 }
        ]
    }
    """

    /// `GET https://mempool.space/api/v1/mining/hashrate/3d`
    static let hashrate = """
    {
        "currentHashrate": 612340000000000000000.0,
        "currentDifficulty": 86388558925171.02
    }
    """

    /// `GET https://mempool.space/api/v1/mining/reward-stats/1`
    static let blockReward = """
    {
        "startBlock": 840000,
        "endBlock": 840000,
        "totalReward": "325000000",
        "totalFee": "12500000",
        "totalTx": "3050"
    }
    """

    /// `GET https://mempool.space/api/v1/difficulty-adjustment`
    static let difficultyAdjustment = """
    {
        "progressPercent": 42.5,
        "difficultyChange": 1.23,
        "estimatedRetargetDate": 1714000000,
        "remainingBlocks": 1160,
        "remainingTime": 700000,
        "previousRetarget": -1.5,
        "nextRetargetHeight": 841056,
        "timeAvg": 600000,
        "timeOffset": 0
    }
    """
}
