from web3 import Web3
import json

#import build/contracts/Arbitrage.json


INFURA_URL = '';
w3 = Web3(Web3.HTTPProvider(INFURA_URL)
w3.eth.defaultAccount = ''

arbitrage_abi = json.loads('[
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        },
        {
          "internalType": "address",
          "name": "srcTokenAddress",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "dstTokenAddress",
          "type": "address"
        }
      ],
      "name": "runTokenKyberUniswap",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        },
        {
          "internalType": "address",
          "name": "srcTokenAddress",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "dstTokenAddress",
          "type": "address"
        }
      ],
      "name": "runTokenUniswapKyber",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "tokenAddress",
          "type": "address"
        }
      ],
      "name": "withdrawETHAndTokens",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]'
)

# to add
#erc20_abi = json.loads()

gas_price = Web3.eth.generateGasPrice()
src_token = web3.eth.contract(abi=erc20_abi, address=src_token_address) 
arbitrage = web3.eth.contract(abi=arbitrage_abi, address=arbitrage_address) 

tx1 = src_token.functions
    .approve(arbitrage_address, 1000) 
    .buildTransaction({
        'chainId': 1, 
        'gasPrice': gas_price, 
        'nonce': web3.eth.getTransactionCount(user_address), 
    })
signed_tx1 = web3.eth.account.signTransaction(tx1, private_key)
tx1_hash = web3.eth.sendRawTransaction(signed_tx1.rawTransaction)
print(tx1_hash)

tx2 = txarbitrage.functions
    .runTokenKyberUniswap(1000, src_address, src_address)
    .buildTransaction({
        'chainId': 1, 
        'gasPrice': gas_price, 
        'nonce': web3.eth.getTransactionCount(user_address), 
        'value': 0
    })
signed_tx2 = web3.eth.account.signTransaction(tx2, private_key)
tx2_hash = web3.eth.sendRawTransaction(signed_tx2.rawTransaction)
print(tx2_hash)
