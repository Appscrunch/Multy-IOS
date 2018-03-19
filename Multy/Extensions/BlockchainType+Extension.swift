//Copyright 2018 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation

typealias BlockchainTypeEquatable = BlockchainType

extension BlockchainTypeEquatable: Equatable {
    static public func == (lhs: BlockchainType, rhs: BlockchainType) -> Bool {
        return lhs.blockchain.rawValue == rhs.blockchain.rawValue && lhs.net_type == rhs.net_type
    }
}

extension BlockchainType {
    var iconString : String {
        var iconString = ""
        
        switch self.blockchain {
        case BLOCKCHAIN_BITCOIN:
            switch UInt32(self.net_type) {
            case BLOCKCHAIN_NET_TYPE_MAINNET.rawValue:
                iconString = "btcIconBig"
            case BLOCKCHAIN_NET_TYPE_TESTNET.rawValue:
                iconString = "btcTest"
            default:
                iconString = ""
            }
        case BLOCKCHAIN_LITECOIN:
            iconString = "chainLtc"
        case BLOCKCHAIN_DASH:
            iconString = "chainDash"
        case BLOCKCHAIN_ETHEREUM:
            switch UInt32(self.net_type) {
            case 0:
                iconString = "ethMediumIcon"
            case 1:
                iconString = "ethTest"
            case 4:
                iconString = "ethTest"
            default:
                iconString = ""
            }
        case BLOCKCHAIN_ETHEREUM_CLASSIC:
            iconString = "chainEtc"
        case BLOCKCHAIN_STEEM:
            iconString = "chainSteem"
        case BLOCKCHAIN_BITCOIN_CASH:
            iconString = "chainBch"
        case BLOCKCHAIN_BITCOIN_LIGHTNING:
            iconString = "chainLbtc"
        case BLOCKCHAIN_GOLOS:
            iconString = "chainGolos"
        case BLOCKCHAIN_BITSHARES:
            iconString = "chainBts"
        case BLOCKCHAIN_ERC20:
            iconString = "chainErc20"
        default:
            iconString = ""
        }
        
        return iconString
    }
    
    var shortName : String {
        var shortName = ""
        
        switch self.blockchain {
        case BLOCKCHAIN_BITCOIN:
            shortName = "BTC"
        case BLOCKCHAIN_LITECOIN:
            shortName = "LTC"
        case BLOCKCHAIN_DASH:
            shortName = "DASH"
        case BLOCKCHAIN_ETHEREUM:
            shortName = "ETH"
        case BLOCKCHAIN_ETHEREUM_CLASSIC:
            shortName = "ETC"
        case BLOCKCHAIN_STEEM:
            shortName = "STEEM"
        case BLOCKCHAIN_BITCOIN_CASH:
            shortName = "BCH"
        case BLOCKCHAIN_BITCOIN_LIGHTNING:
            shortName = "LBTC"
        case BLOCKCHAIN_GOLOS:
            shortName = "GOLOS"
        case BLOCKCHAIN_BITSHARES:
            shortName = "BTS"
        case BLOCKCHAIN_ERC20:
            shortName = "ERC20"
        default:
            shortName = ""
        }
        
        return shortName
    }
    
    var fullName : String {
        var fullName = ""
        
        switch self.blockchain {
        case BLOCKCHAIN_BITCOIN:
            fullName = "Bitcoin"
        case BLOCKCHAIN_LITECOIN:
            fullName = "Litecoin"
        case BLOCKCHAIN_DASH:
            fullName = "Dash"
        case BLOCKCHAIN_ETHEREUM:
            fullName = "Ethereum"
        case BLOCKCHAIN_ETHEREUM_CLASSIC:
            fullName = "Ethereum Classic"
        case BLOCKCHAIN_STEEM:
            fullName = "Steem Dollars"
        case BLOCKCHAIN_BITCOIN_CASH:
            fullName = "Bitcoin Cash"
        case BLOCKCHAIN_BITCOIN_LIGHTNING:
            fullName = "Bitcoin lightning"
        case BLOCKCHAIN_GOLOS:
            fullName = "Golos"
        case BLOCKCHAIN_BITSHARES:
            fullName = "BitShares"
        case BLOCKCHAIN_ERC20:
            fullName = "ERC20 Tokens"
        default:
            fullName = ""
        }
        
        return fullName
    }
    
    static func getAvailableBlockchain(index: UInt32) -> BlockchainType {
        switch index {
        case 0:
            return BlockchainType.create(currencyID: BLOCKCHAIN_BITCOIN.rawValue, netType: BLOCKCHAIN_NET_TYPE_MAINNET.rawValue)
        case 1:
            return BlockchainType.create(currencyID: BLOCKCHAIN_ETHEREUM.rawValue, netType: BLOCKCHAIN_NET_TYPE_MAINNET.rawValue)
        default:
            return BlockchainType.create(currencyID: BLOCKCHAIN_BITCOIN.rawValue, netType: BLOCKCHAIN_NET_TYPE_MAINNET.rawValue)
        }
    }
    
    static func getDonationBlockchain(index: UInt32) -> BlockchainType {
        let mainnetType = BLOCKCHAIN_NET_TYPE_MAINNET.rawValue
        switch index {
        case 0:
            return BlockchainType.create(currencyID: BLOCKCHAIN_BITCOIN.rawValue, netType: mainnetType)
        case 1:
            return BlockchainType.create(currencyID: BLOCKCHAIN_ETHEREUM.rawValue, netType: mainnetType)
        default:
            return BlockchainType.create(currencyID: BLOCKCHAIN_BITCOIN.rawValue, netType: mainnetType)
        }
    }
    
    static func create(wallet: UserWalletRLM) -> BlockchainType {
        return BlockchainType.create(currencyID: wallet.chain.uint32Value, netType: wallet.chainType.uint32Value)
    }
    
    static func create(currencyID: UInt32, netType: UInt32) -> BlockchainType {
        return BlockchainType.init(blockchain: Blockchain.init(currencyID), net_type: Int(netType))
    }
}
