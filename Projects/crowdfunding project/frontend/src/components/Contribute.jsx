

import { useState } from 'react'
import { useWriteContract } from 'wagmi'
import { crowdfundingABI } from '../abi'
import { parseEther } from 'viem'

const CONTRACT = "0x53da9C3444085D4b3c50Fc38A0a96Cf18413C2D5"

export default function Contribute() {
  const [isLoading, setIsLoading] = useState(false)
  const [message, setMessage] = useState('')
  const [formData, setFormData] = useState({ id: '', amount: '' })
  
  const { writeContract } = useWriteContract()

  async function contribute() {
    const { id, amount } = formData
    
  
    if (!id || !amount) {
      setMessage('Please fill in both fields')
      return
    }
    
    if (parseFloat(amount) <= 0) {
      setMessage('Amount must be greater than 0')
      return
    }
    
    if (parseInt(id) < 0) {
      setMessage('Campaign ID must be a positive number')
      return
    }

    setIsLoading(true)
    setMessage('')

    try {
      writeContract({
        address: CONTRACT,
        abi: crowdfundingABI,
        functionName: "contribute",
        args: [Number(id)],
        value: parseEther(amount),
      })
      setMessage('Contribution submitted! Check MetaMask for confirmation.')
      setFormData({ id: '', amount: '' })
    } catch (error) {
      setMessage(`Error: ${error.message}`)
    } finally {
      setIsLoading(false)
    }
  }

  const handleInputChange = (e) => {
    setFormData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }))
  }

  return (
    <div style={{ 
      padding: '20px', 
      border: '1px solid #ddd', 
      borderRadius: '8px', 
      margin: '10px 0' 
    }}>
      <h3>Contribute</h3>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
        <input 
          name="id"
          placeholder="Campaign ID" 
          value={formData.id}
          onChange={handleInputChange}
          disabled={isLoading}
        />
        <input 
          name="amount"
          placeholder="ETH amount" 
          value={formData.amount}
          onChange={handleInputChange}
          disabled={isLoading}
        />
        <button 
          onClick={contribute} 
          disabled={isLoading}
          style={{ 
            padding: '10px',
            backgroundColor: isLoading ? '#ccc' : '#28a745',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: isLoading ? 'not-allowed' : 'pointer'
          }}
        >
          {isLoading ? 'Contributing...' : 'Contribute'}
        </button>
      </div>
      {message && (
        <div style={{ 
          marginTop: '10px', 
          padding: '10px',
          backgroundColor: message.includes('Error') ? '#f8d7da' : '#d4edda',
          color: message.includes('Error') ? '#721c24' : '#155724',
          border: `1px solid ${message.includes('Error') ? '#f5c6cb' : '#c3e6cb'}`,
          borderRadius: '4px'
        }}>
          {message}
        </div>
      )}
    </div>
  )
}
