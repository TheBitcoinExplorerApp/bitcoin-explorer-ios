//
//  Blockchain.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

struct Blockchain: View {
    
    @State var abrirModal: Bool = false
    @State var blockHeader: Block?
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(BlocksTexts.blockchain)
                    .foregroundColor(Color.texts)
                    .bold()
                    .font(.headline)
                Spacer()
            }.padding(.leading)
            
            ScrollView(.horizontal) {
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 5)
                        .foregroundStyle(Color.chainBackground)
                    
                    HStack(spacing: 10) {
                        mempool
                        ForEach(viewModel.blockHeaderData, id: \.self) { block in
                        
                            VStack {
                                let tamanho = formatSizeToMB(block.size)
                                
                                Text("\(block.height)").foregroundColor(Color.primaryText)
                                    .font(.callout)
                                    .bold()
                                Text("~\(Int(block.extras.medianFee)) \(Texts.satVb)").foregroundColor(Color.texts)
                                    .font(.footnote)
                                Text("\(tamanho) \(BlocksTexts.MB)").foregroundColor(Color.texts)
                                    .font(.callout)
                                Text("\(block.tx_count) \(TransactionsTexts.transacoes)").foregroundColor(Color.texts)
                                    .truncationMode(.tail)
                                    .font(.footnote)
                                Text("\(block.formatTimestamp(block.timestamp))").foregroundColor(Color.texts)
                                    .font(.footnote)
                                
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .frame(width: 10, height: 5)
                            }
                            .padding()
                            .background(Color.backgroundBox)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .onTapGesture {
                                self.blockHeader = block
                                abrirModal.toggle()
                            }
                            
                        }
                    }
                }.padding(.leading)
            }.scrollIndicators(.hidden)
            
        }
        .sheet(isPresented: $abrirModal) {
            EachBlock(abrirModal: $abrirModal, blockHeader: $blockHeader)
                .presentationBackground(Color.background)
        }
    }
    
    var mempool: some View {
        VStack {
            Text(BlocksTexts.mempoolTitle)
                .font(.callout)
                .bold()
                .foregroundStyle(Color.texts)
            
            Text("\(viewModel.mempoolData?.count ?? 0) \(TransactionsTexts.transacoes)")
                .foregroundStyle(Color.texts)
                .font(.footnote)
            
            Text("\(formatSizeToMB(viewModel.getTotalMempoolSize())) \(BlocksTexts.MB)")
                .foregroundStyle(Color.primaryText)
                .font(.callout)
                .bold()
            
            Text("\(TransactionsTexts.taxaMaiusculo): \(String(format: "%.8f", mempoolFees(viewModel.mempoolData?.total_fee ?? 0))) BTC")
                .foregroundStyle(Color.texts)
                .font(.footnote)
            
            Text("\(viewModel.getTotalMempoolVSize()) \(BlocksTexts.blocos)")
                .foregroundStyle(Color.texts)
                .font(.footnote)
        }
        .padding()
        .background(Color.backgroundBox)
        .clipShape(RoundedRectangle(cornerRadius: 7))
        .overlay {
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.primaryText, lineWidth: 1)
        }
    }
    
    func mempoolFees(_ totalFee: Double) -> Double {
        return totalFee / 100000000
    }
    
    func formatSizeToMB(_ size: Double) -> String {
        String(format: "%.2f", (size / 1000000))
    }
    
}

#Preview {
    Blockchain()
        .environmentObject(HomeViewModel())
}
#Preview {
    return HomeView()
        .environmentObject(CurrencyViewModel())
        .environmentObject(AddManager())
}
