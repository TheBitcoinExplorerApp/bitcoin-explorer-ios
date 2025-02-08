//
//  HalvingSpecificView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 07/02/25.
//

import SwiftUI

struct HalvingSpecificView: View {
    @StateObject var viewModel = HalvingSpecificViewModel()
    @EnvironmentObject private var lastBlockViewModel: LastBlockViewModel
    
    var body: some View {
        List {
            if viewModel.hasFinishedHalving {
                Text(Texts.halvingCountdownFinished)
                    .font(.title2)
                    .foregroundStyle(Color.primaryText)
                    .listRowBackground(Color.backgroundBox)
            } else {
                
                Section {
                    Text("Next Halving at height: ")
                        .font(.callout)
                    + Text("\(viewModel.getNextHalvingBlockHeight(lastBlockViewModel.lastBlock))")
                        .foregroundColor(Color.primaryText)
                        .font(.title2)
                        .bold()
                    
                    Text("Current Block Reward: ")
                        .font(.callout)
                    +
                    Text("\(getFormattedBlockReward(viewModel.getCurrentBlockReward(lastBlockViewModel.lastBlock)))")
                        .foregroundColor(Color.primaryText)
                        .font(.system(.headline, weight: .semibold))
                    
                    Text("Next Block Reward: ")
                        .font(.callout)
                    +
                    Text("\(getFormattedBlockReward(viewModel.getNextBlockReward(lastBlockViewModel.lastBlock)))")
                        .foregroundColor(Color.primaryText)
                        .font(.system(.headline, weight: .semibold))
                }
                .foregroundStyle(Color.texts)
                .listRowBackground(Color.backgroundBox)
                
                Section {
                    Text("Estimated date to next halving:\n")
                        .font(.body)
                    +
                    Text("\(viewModel.getNextHalvingTime(lastBlockViewModel.lastBlock))\n")
                        .foregroundColor(Color.primaryText)
                        .font(.system(.headline, weight: .semibold))
                    +
                    Text("Assumed Block Interval of 10 minutes")
                        .font(.caption2)
                }
                .foregroundStyle(Color.texts)
                .listRowBackground(Color.backgroundBox)
                
                Section("Previous and upcomming halvings") {
                    ForEach(Array(viewModel.halvings.enumerated()), id: \.element.id) { index, halving in
                        VStack(alignment: .leading) {
                            Text("Halving \(index + 1) at height ")
                                .font(.title3)
                            +
                            Text("\(halving.blockHeight)")
                                .foregroundColor(Color.primaryText)
                                .font(.title3)
                                .bold()
                            
                            Text("\(formatTipeFullDate(halving.estimatedTime))")
                                .font(.subheadline)
                            
                            Text("New Block Reward: ")
                                .font(.footnote)
                            +
                            Text("\(getFormattedBlockReward(halving.newBlockReward))")
                                .foregroundColor(Color.primaryText)
                                .font(.footnote)
                                .bold()
                        }
                        .foregroundStyle(Color.texts)
                    }
                }
                .listRowBackground(Color.backgroundBox)
            }
        }
        .background(Color.myBackground)
        .scrollContentBackground(.hidden)
        
        .task {
            lastBlockViewModel.fetchLastBlock()
        }
            
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Halvings")
                    .foregroundStyle(Color.texts)
            }
        }
        
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
    HalvingSpecificView()
        .environmentObject(LastBlockViewModel())
}
