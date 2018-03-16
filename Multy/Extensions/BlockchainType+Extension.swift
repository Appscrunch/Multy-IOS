//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

extension BlockchainType {
    var iconString : String {
        var iconString = ""
        
        switch self.blockchain.rawValue {
        case BLOCKCHAIN_BITCOIN.rawValue:
            switch UInt32(self.net_type) {
            case BLOCKCHAIN_NET_TYPE_MAINNET.rawValue:
                iconString = "btcIconBig"
            case BLOCKCHAIN_NET_TYPE_TESTNET.rawValue:
                iconString = "btcTest"
            default:
                iconString = ""
            }
        case BLOCKCHAIN_ETHEREUM.rawValue:
            switch UInt32(self.net_type) {
            case 0:
                iconString = "ethMediumIcon"
            case 1:
                iconString = "ethTest"
            default:
                iconString = ""
            }
        default:
            iconString = " "
        }
        
        return iconString
    }
    
    var shortName : String {
        var shortName = ""
        
        switch self.blockchain.rawValue {
        case BLOCKCHAIN_BITCOIN.rawValue:
            shortName = "BTC"
        case BLOCKCHAIN_ETHEREUM.rawValue:
            shortName = "ETH"
        default:
            shortName = ""
        }
        
        return shortName
    }
    
    static func create(wallet: UserWalletRLM) -> BlockchainType {
        return BlockchainType.create(currencyID: wallet.chain.uint32Value, netType: wallet.chainType.uint32Value)
    }
    
    static func create(currencyID: UInt32, netType: UInt32) -> BlockchainType {
        return BlockchainType.init(blockchain: Blockchain.init(currencyID), net_type: Int(netType))
    }
}
