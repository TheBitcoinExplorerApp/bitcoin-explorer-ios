//
//  HalvingSpecificView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 07/02/25.
//

import SwiftUI

struct HalvingSpecificView: View {
    @StateObject var viewModel = HalvingSpecificViewModel()
    let lastBlock: Int64
    
    var body: some View {
        Form {
            if viewModel.hasFinishedHalving {
                Text(Texts.halvingCountdownFinished)
                    .font(.title2)
                    .foregroundStyle(Color.primaryText)
                    .listRowBackground(Color.backgroundBox)
            } else {
                
                Section {
                    Text("\(Texts.nextHalvingAtHeight) ")
                        .font(.callout)
                    + Text("\(viewModel.getNextHalvingBlockHeight(lastBlock))")
                        .foregroundColor(Color.primaryText)
                        .font(.title2)
                        .bold()
                    
                    Text("\(Texts.currentBlockReward) ")
                        .font(.callout)
                    +
                    Text("\(getFormattedBlockReward(viewModel.getCurrentBlockReward(lastBlock)))")
                        .foregroundColor(Color.primaryText)
                        .font(.system(.headline, weight: .semibold))
                    
                    Text("\(Texts.nextBlockReward) ")
                        .font(.callout)
                    +
                    Text("\(getFormattedBlockReward(viewModel.getNextBlockReward(lastBlock)))")
                        .foregroundColor(Color.primaryText)
                        .font(.system(.headline, weight: .semibold))
                }
                .foregroundStyle(Color.texts)
                .listRowBackground(Color.backgroundBox)
                
                Section {
                    Text("\(Texts.estimatedDate)\n")
                        .font(.body)
                    +
                    Text("\(viewModel.getNextHalvingTime(lastBlock))\n")
                        .foregroundColor(Color.primaryText)
                        .font(.system(.headline, weight: .semibold))
                    +
                    Text(Texts.assumedBlockInterval)
                        .font(.caption2)
                }
                .foregroundStyle(Color.texts)
                .listRowBackground(Color.backgroundBox)
                
                Section(Texts.previousAndUpcoming) {
                    ForEach(Array(viewModel.getHalvingsPassedAndNot(lastBlock).enumerated()), id: \.element.id) { index, halving in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(Texts.halving) \(index + 1) \(Texts.atHeight) ")
                                    .font(.title3)
                                +
                                Text("\(halving.blockHeight)")
                                    .foregroundColor(Color.primaryText)
                                    .font(.title3)
                                    .bold()
                                
                                Text("\(formatTimeFullDate(halving.estimatedTime))")
                                    .font(.subheadline)
                                
                                Text("\(Texts.newBlockReward) ")
                                    .font(.footnote)
                                +
                                Text("\(getFormattedBlockReward(halving.newBlockReward))")
                                    .foregroundColor(Color.primaryText)
                                    .font(.footnote)
                                    .bold()
                            }
                            .foregroundStyle(Color.texts)
                            
                            Spacer()
                            
                            if halving.hasPassed {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 22)
                                    .foregroundStyle(Color.primaryText)
                            }
                        }
                    }
                }
                .listRowBackground(Color.backgroundBox)
            }
        }
        .background(Color.myBackground)
        .scrollContentBackground(.hidden)
        
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(Texts.halvings)
                    .foregroundStyle(Color.texts)
            }
        }
        .toolbarBackgroundIfNeeded(Color.myBackground)
        
    }
    
    func getFormattedBlockReward(_ reward: Double) -> String {
        if Int(reward) > 0 {
            return "\(removeTrailingZeros(from: reward)) BTC"
        } else {
            let stringValue = String(format: "%.50f", reward)
            let stringNumber = stringValue.replacingOccurrences(of: ",", with: ".")
            
            // Precise representation
            guard let decimalPart = stringNumber.split(separator: ".").last else {
                return ""
            }
            
            if decimalPart.first == "0" {
                // If first number after comma equal to zero
                return String(format: "%.0f \(Texts.Sats)", reward * Double.BtcInSats)
            } else {
                return "\(removeTrailingZeros(from: reward)) BTC"
            }
        }
    }
    
    func removeTrailingZeros(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8 // Até 8 casas decimais
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
}

#Preview {
    HalvingSpecificView(lastBlock: 1)
        .environmentObject(LastBlockViewModel())
}
