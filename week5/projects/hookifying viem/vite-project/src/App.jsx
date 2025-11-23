import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { parseEther } from 'viem'
import { http, createConfig, WagmiProvider, useConnect, useAccount, useBalance, useConnection, useSendTransaction, useDisconnect } from 'wagmi'
import {  mainnet,sepolia} from 'wagmi/chains'
import { injected } from 'wagmi/connectors'
// import { useAccount } from 'wagmi'



export const config = createConfig({
  chains: [sepolia],
  connectors: [
    injected(),
    // metaMask(),
  ],
  transports: {
    [sepolia.id]: http(),
    // [base.id]: http(),
  },
})
const queryclinet=new QueryClient();
function App() {
 
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryclinet}>
        <WalletConnector>

        </WalletConnector>
         <Ethsend/>
    <Myaddress/>
    <DisconnectWallet/>
      </QueryClientProvider>
    </WagmiProvider>
  )
}
function Myaddress(){
  const { address, status } = useConnection()
  const balance =useBalance({address});
  console.log(balance);
  return(
    <div>
      {address}
      <br />
      {/* console.log(balance) */}
      {balance?.data?.formatted}
    </div>
  )
}
function WalletConnector(){
  const {connectors,connect}=useConnect();
 return connectors.map((connector) => (
    <button key={connector.uid} onClick={() => connect({ connector })}>
      {connector.name}
    </button>
  ))  
   
}
function DisconnectWallet() {
  const { disconnect } = useDisconnect()
  const { status } = useConnection()

  // Show button only when connected
  if (status !== 'connected') return null

  return (
    <button onClick={() => disconnect()}>
      Disconnect Wallet
    </button>
  )
}

function Ethsend(){
   const { data: hash, sendTransaction } = useSendTransaction()
     

      function sendeth() {
    
        sendTransaction({ 
               to : document.getElementById("address").value,
       value: parseEther("0.1")
         })
    }


  return (
    <div>
        
        <input id="address" type="text" placeholder="Adreess.."></input>
<button onClick={sendeth}> Send 0.1ETH</button>      
    </div>
  )
}

export default App
