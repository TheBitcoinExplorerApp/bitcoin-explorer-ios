//
//  Halvings.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 29/01/25.
//

import Foundation

struct Halving: Equatable {
    let blockHeight: Int64
    let estimatedTime: TimeInterval
    let newBlockReward: Double
}

enum Halvings: CaseIterable {
    case halving1, halving2, halving3, halving4, halving5,
         halving6, halving7, halving8, halving9, halving10,
         halving11, halving12, halving13, halving14, halving15,
         halving16, halving17, halving18, halving19, halving20,
         halving21, halving22, halving23, halving24, halving25,
         halving26, halving27, halving28, halving29, halving30,
         halving31, halving32, halving33
    
    var halvings: Halving {
        switch self {
        case .halving1:
            return Halving(blockHeight: 210000, estimatedTime: 1354109078, newBlockReward: 25.0)
        case .halving2:
            return Halving(blockHeight: 420000, estimatedTime: 1468071973, newBlockReward: 12.5)
        case .halving3:
            return Halving(blockHeight: 630000, estimatedTime: 1589214223, newBlockReward: 6.25)
        case .halving4:
            return Halving(blockHeight: 840000, estimatedTime: 1713560967, newBlockReward: 3.125)
        case .halving5:
            return Halving(blockHeight: 1050000, estimatedTime: 1839560967, newBlockReward: 1.5625)
        case .halving6:
            return Halving(blockHeight: 1260000, estimatedTime: 1965560967, newBlockReward: 0.78125)
        case .halving7:
            return Halving(blockHeight: 1470000, estimatedTime: 2091560967, newBlockReward: 0.390625)
        case .halving8:
            return Halving(blockHeight: 1680000, estimatedTime: 2217560967, newBlockReward: 0.1953125)
        case .halving9:
            return Halving(blockHeight: 1890000, estimatedTime: 2343560967, newBlockReward: 0.09765625)
        case .halving10:
            return Halving(blockHeight: 2100000, estimatedTime: 2469560967, newBlockReward: 0.048828125)
        case .halving11:
            return Halving(blockHeight: 2310000, estimatedTime: 2595560967, newBlockReward: 0.0244140625)
        case .halving12:
            return Halving(blockHeight: 2520000, estimatedTime: 2721560967, newBlockReward: 0.01220703125)
        case .halving13:
            return Halving(blockHeight: 2730000, estimatedTime: 2847560967, newBlockReward: 0.006103515625)
        case .halving14:
            return Halving(blockHeight: 2940000, estimatedTime: 2973560967, newBlockReward: 0.0030517578125)
        case .halving15:
            return Halving(blockHeight: 3150000, estimatedTime: 3099560967, newBlockReward: 0.00152587890625)
        case .halving16:
            return Halving(blockHeight: 3360000, estimatedTime: 3225560967, newBlockReward: 0.000762939453125)
        case .halving17:
            return Halving(blockHeight: 3570000, estimatedTime: 3351560967, newBlockReward: 0.0003814697265625)
        case .halving18:
            return Halving(blockHeight: 3780000, estimatedTime: 3477560967, newBlockReward: 0.00019073486328125)
        case .halving19:
            return Halving(blockHeight: 3990000, estimatedTime: 3603560967, newBlockReward: 0.000095367431640625)
        case .halving20:
            return Halving(blockHeight: 4200000, estimatedTime: 3729560967, newBlockReward: 0.0000476837158203125)
        case .halving21:
            return Halving(blockHeight: 4410000, estimatedTime: 3855560967, newBlockReward: 0.00002384185791015625)
        case .halving22:
            return Halving(blockHeight: 4620000, estimatedTime: 3981560967, newBlockReward: 0.000011920928955078125)
        case .halving23:
            return Halving(blockHeight: 4830000, estimatedTime: 4107560967, newBlockReward: 0.0000059604644775390625)
        case .halving24:
            return Halving(blockHeight: 5040000, estimatedTime: 4233560967, newBlockReward: 0.00000298023223876953125)
        case .halving25:
            return Halving(blockHeight: 5250000, estimatedTime: 4359560967, newBlockReward: 0.000001490116119384765625)
        case .halving26:
            return Halving(blockHeight: 5460000, estimatedTime: 4485560967, newBlockReward: 0.0000007450580596923828125)
        case .halving27:
            return Halving(blockHeight: 5670000, estimatedTime: 4611560967, newBlockReward: 0.00000037252902984619140625)
        case .halving28:
            return Halving(blockHeight: 5880000, estimatedTime: 4737560967, newBlockReward: 0.000000186264514923095703125)
        case .halving29:
            return Halving(blockHeight: 6090000, estimatedTime: 4863560967, newBlockReward: 0.0000000931322574615478515625)
        case .halving30:
            return Halving(blockHeight: 6300000, estimatedTime: 4989560967, newBlockReward: 0.00000004656612873077392578125)
        case .halving31:
            return Halving(blockHeight: 6510000, estimatedTime: 5115560967, newBlockReward: 0.000000023283064365386962890625)
        case .halving32:
            return Halving(blockHeight: 6720000, estimatedTime: 5241560967, newBlockReward: 0.0000000116415321826934814453125)
        case .halving33:
            return Halving(blockHeight: 6930000, estimatedTime: 5367560967, newBlockReward: 0.00000000582076609134674072265625)
        }
    }
}
