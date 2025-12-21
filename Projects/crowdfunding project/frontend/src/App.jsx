import { WagmiProvider } from 'wagmi'
import { config } from './config'
import { useAccount, useConnect } from 'wagmi'
import CreateCampaign from './components/CreateCampaign.jsx'
import Contribute from './components/Contribute.jsx'
import Withdraw from './components/Withdraw.jsx'
import Refund from './components/Refund.jsx'

function AppContent() {
  const { address } = useAccount()
  const { connect, isPending, error } = useConnect()

  function handleConnect() {
    connect({ connector: injected() })
  }

  return (
    <div style={{ padding: 30 }}>
      <h1>Crowdfunding dApp</h1>

      {address ? (
        <>
          <div style={{ marginBottom: 20 }}>
            <p>Connected: {address.slice(0, 6)}...{address.slice(-4)}</p>
          </div>
          <CreateCampaign />
          <Contribute />
          <Withdraw />
          <Refund />
        </>
      ) : (
        <div style={{ textAlign: 'center', padding: 40 }}>
          <h2>Connect Your Wallet</h2>
          <button 
            onClick={handleConnect} 
            disabled={isPending}
            style={{
              padding: '12px 24px',
              fontSize: '16px',
              backgroundColor: '#007bff',
              color: 'white',
              border: 'none',
              borderRadius: '8px',
              cursor: isPending ? 'not-allowed' : 'pointer'
            }}
          >
            {isPending ? 'Connecting...' : 'Connect MetaMask'}
          </button>
          
          {error && (
            <div style={{ marginTop: 16, color: 'red' }}>
              <p>Connection failed: {error.message}</p>
              <p>Make sure MetaMask is installed and unlocked.</p>
            </div>
          )}
        </div>
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