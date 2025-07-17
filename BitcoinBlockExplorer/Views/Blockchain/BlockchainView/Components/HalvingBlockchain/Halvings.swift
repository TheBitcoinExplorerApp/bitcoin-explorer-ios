//
//  Halvings.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 29/01/25.
//

import Foundation

struct Halving: Hashable, Equatable, Identifiable {
    let id = UUID()
    let blockHeight: Int64
    let estimatedTime: TimeInterval
    let newBlockReward: Double
    var hasPassed: Bool = false
}

struct Halvings {
    
    var halvings: [Halving] = [
        Halving(blockHeight: 210000, estimatedTime: 1354109078, newBlockReward: 25.0),
        Halving(blockHeight: 420000, estimatedTime: 1468071973, newBlockReward: 12.5),
        Halving(blockHeight: 630000, estimatedTime: 1589214223, newBlockReward: 6.25),
        Halving(blockHeight: 840000, estimatedTime: 1713560967, newBlockReward: 3.125),
        Halving(blockHeight: 1050000, estimatedTime: 1839560967, newBlockReward: 1.5625),
        Halving(blockHeight: 1260000, estimatedTime: 1965560967, newBlockReward: 0.78125),
        Halving(blockHeight: 1470000, estimatedTime: 2091560967, newBlockReward: 0.390625),
        Halving(blockHeight: 1680000, estimatedTime: 2217560967, newBlockReward: 0.1953125),
        Halving(blockHeight: 1890000, estimatedTime: 2343560967, newBlockReward: 0.09765625),
        Halving(blockHeight: 2100000, estimatedTime: 2469560967, newBlockReward: 0.048828125),
        Halving(blockHeight: 2310000, estimatedTime: 2595560967, newBlockReward: 0.0244140625),
        Halving(blockHeight: 2520000, estimatedTime: 2721560967, newBlockReward: 0.01220703125),
        Halving(blockHeight: 2730000, estimatedTime: 2847560967, newBlockReward: 0.006103515625),
        Halving(blockHeight: 2940000, estimatedTime: 2973560967, newBlockReward: 0.0030517578125),
        Halving(blockHeight: 3150000, estimatedTime: 3099560967, newBlockReward: 0.00152587890625),
        Halving(blockHeight: 3360000, estimatedTime: 3225560967, newBlockReward: 0.000762939453125),
        Halving(blockHeight: 3570000, estimatedTime: 3351560967, newBlockReward: 0.0003814697265625),
        Halving(blockHeight: 3780000, estimatedTime: 3477560967, newBlockReward: 0.00019073486328125),
        Halving(blockHeight: 3990000, estimatedTime: 3603560967, newBlockReward: 0.000095367431640625),
        Halving(blockHeight: 4200000, estimatedTime: 3729560967, newBlockReward: 0.0000476837158203125),
        Halving(blockHeight: 4410000, estimatedTime: 3855560967, newBlockReward: 0.00002384185791015625),
        Halving(blockHeight: 4620000, estimatedTime: 3981560967, newBlockReward: 0.000011920928955078125),
        Halving(blockHeight: 4830000, estimatedTime: 4107560967, newBlockReward: 0.0000059604644775390625),
        Halving(blockHeight: 5040000, estimatedTime: 4233560967, newBlockReward: 0.00000298023223876953125),
        Halving(blockHeight: 5250000, estimatedTime: 4359560967, newBlockReward: 0.000001490116119384765625),
        Halving(blockHeight: 5460000, estimatedTime: 4485560967, newBlockReward: 0.0000007450580596923828125),
        Halving(blockHeight: 5670000, estimatedTime: 4611560967, newBlockReward: 0.00000037252902984619140625),
        Halving(blockHeight: 5880000, estimatedTime: 4737560967, newBlockReward: 0.000000186264514923095703125),
        Halving(blockHeight: 6090000, estimatedTime: 4863560967, newBlockReward: 0.0000000931322574615478515625),
        Halving(blockHeight: 6300000, estimatedTime: 4989560967, newBlockReward: 0.00000004656612873077392578125),
        Halving(blockHeight: 6510000, estimatedTime: 5115560967, newBlockReward: 0.000000023283064365386962890625),
        Halving(blockHeight: 6720000, estimatedTime: 5241560967, newBlockReward: 0.0000000116415321826934814453125),
        Halving(blockHeight: 6930000, estimatedTime: 5367560967, newBlockReward: 0.0)
    ]
    
}
