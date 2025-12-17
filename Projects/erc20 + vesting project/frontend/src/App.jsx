import { WalletConnect } from './components/WalletConnect'
import { VestingDashboard } from './components/VestingDashboard'
import { AdminPanel } from './components/AdminPanel'

function App() {
  return (
    <div style={{ padding: 40 }}>
      <h1>ERC20 Vesting Dashboard</h1>
      <WalletConnect />
      <VestingDashboard />
      <AdminPanel />
    </div>
  )
}

export default App
