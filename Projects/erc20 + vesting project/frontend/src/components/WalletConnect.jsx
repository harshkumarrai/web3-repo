import { useAccount, useConnect, useDisconnect } from 'wagmi'
import { injected } from 'wagmi/connectors'

export function WalletConnect() {
  const account = useAccount()
  const connectHook = useConnect()
  const disconnectHook = useDisconnect()




  if (account.status === 'connected') {
    return (
      <div>
        <p>Connected: {account.address}</p>
        <button onClick={() => disconnectHook.disconnect()}>
          Disconnect
        </button>
      </div>
    )
  }

  if (account.status === 'connecting') return <div>Connecting...</div>
  if (account.status === 'reconnecting') return <div>Reconnecting...</div>

  return (
    <div>
      {connectHook.connectors.map((connector) => (
        <button
          key={connector.uid}
          onClick={() => connectHook.connect({ connector })}
          type="button"
        >
          {connector.name}
        </button>
      ))}
      <div>{connectHook.error?.message}</div>
    </div>
  )
}
