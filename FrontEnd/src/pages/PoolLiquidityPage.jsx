// src/pages/PoolLiquidityPage.jsx

import { useState, useEffect } from "react";
import TokenSelector from "../components/TokenSelector";
import LPTokenPreview from "../components/LPTokenPreview";


export default function PoolLiquidityPage() {
  const [tokenA, setTokenA] = useState(null);
  const [tokenB, setTokenB] = useState(null);
  const [amountA, setAmountA] = useState("");
  const [amountB, setAmountB] = useState("");
  const [lpTokens, setLpTokens] = useState("");

  useEffect(() => {
    if (amountA && amountB && tokenA && tokenB) {
      // 💡 Simulación: 1 LP token por 100 unidades de cada token
      const estimatedLP = (
        (parseFloat(amountA) + parseFloat(amountB)) /
        200
      ).toFixed(4);
      setLpTokens(estimatedLP);
    } else {
      setLpTokens("");
    }
  }, [amountA, amountB, tokenA, tokenB]);

  return (
    <div className="max-w-md mx-auto mt-10 p-6 bg-white shadow rounded">
      <h2 className="text-2xl font-bold mb-6 text-center">Add Liquidity</h2>

      <div className="mb-4">
        <label className="block mb-1 font-semibold">Token A:</label>
        <TokenSelector selectedToken={tokenA} onChange={setTokenA} />
        <input
          type="number"
          className="mt-2 w-full border rounded px-3 py-2"
          placeholder="Amount of Token A"
          value={amountA}
          onChange={(e) => setAmountA(e.target.value)}
        />
      </div>

      <div className="mb-4">
        <label className="block mb-1 font-semibold">Token B:</label>
        <TokenSelector selectedToken={tokenB} onChange={setTokenB} />
        <input
          type="number"
          className="mt-2 w-full border rounded px-3 py-2"
          placeholder="Amount of Token B"
          value={amountB}
          onChange={(e) => setAmountB(e.target.value)}
        />
      </div>

      {lpTokens && (
        <LPTokenPreview
         tokenA={tokenA}
         tokenB={tokenB}
         amountA={amountA}
         amountB={amountB}
         lpTokens={lpTokens}
        />
      )}

      <button className="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
        Add Liquidity
      </button>
    </div>
  );
}
