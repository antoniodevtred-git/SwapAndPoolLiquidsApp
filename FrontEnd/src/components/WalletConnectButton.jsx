// src/components/WalletConnectButton.jsx

import { useAccount, useConnect, useDisconnect } from 'wagmi';
import { injected } from 'wagmi/connectors';

export default function WalletConnectButton() {
  const { connect, isPending } = useConnect({
    connector: injected(),
  });

  const { disconnect } = useDisconnect();
  const { isConnected, address } = useAccount();

  const shortenAddress = (addr) =>
    `${addr.slice(0, 6)}...${addr.slice(-4)}`;

  return (
    <div className="flex flex-col items-center gap-4 mt-4">
      {!isConnected ? (
        <button
          onClick={() => connect()}
          className="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700"
        >
          {isPending ? 'Conectando...' : 'Conectar Wallet'}
        </button>
      ) : (
        <>
          <span className="text-sm text-gray-700">
            Conectado: <strong>{shortenAddress(address)}</strong>
          </span>
          <button
            onClick={() => disconnect()}
            className="bg-red-600 text-white px-6 py-2 rounded hover:bg-red-700"
          >
            Desconectar
          </button>
        </>
      )}
    </div>
  );
}
