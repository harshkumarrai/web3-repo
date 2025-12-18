import { WagmiProvider } from 'wagmi'
import { config } from './config'

import { useAccount } from 'wagmi'
import CreateCampaign from './components/CreateCampaign.jsx'
import Contribute from './components/Contribute.jsx'
import Withdraw from './components/Withdraw.jsx'
import Refund from './components/Refund.jsx'

function AppContent() {
  const { address } = useAccount()

  return (
    <div style={{ padding: 30 }}>
      <h1>Crowdfunding dApp</h1>

      {address ? (
        <>
          <CreateCampaign />
          <Contribute />
          <Withdraw />
          <Refund />
        </>
      ) : (
        <p>Connect MetaMask</p>
      )}
    </div>
  )
}

export default function App() {
  return (
    <WagmiProvider config={config}>
      <AppContent />
    </WagmiProvider>
  )
}
