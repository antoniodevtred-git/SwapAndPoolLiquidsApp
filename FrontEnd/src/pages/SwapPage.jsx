import { useState, useEffect } from "react";
import TokenSelector from "../components/TokenSelector";

export default function SwapPage() {
  const [tokenIn, setTokenIn] = useState(null);
  const [tokenOut, setTokenOut] = useState(null);
  const [amountIn, setAmountIn] = useState("");
  const [estimatedAmountOut, setEstimatedAmountOut] = useState("");

  const handleAmountChange = (e) => {
    setAmountIn(e.target.value);
  };

  useEffect(() => {
    if (tokenIn && tokenOut && amountIn) {
      const estimated = (parseFloat(amountIn) * 1000).toFixed(4);
      setEstimatedAmountOut(estimated);
    } else {
      setEstimatedAmountOut("");
    }
  }, [tokenIn, tokenOut, amountIn]);

  return (
    <div className="max-w-md mx-auto mt-10 p-6 bg-white shadow rounded">
      <h2 className="text-2xl font-bold mb-6 text-center">Swap Tokens</h2>

      <div className="mb-4">
        <label className="block mb-1 font-semibold">From:</label>
        <TokenSelector selectedToken={tokenIn} onChange={setTokenIn} />
        <input
          type="number"
          className="mt-2 w-full border rounded px-3 py-2"
          placeholder="Amount to swap"
          value={amountIn}
          onChange={handleAmountChange}
        />
      </div>

      <div className="mb-4">
        <label className="block mb-1 font-semibold">To:</label>
        <TokenSelector selectedToken={tokenOut} onChange={setTokenOut} />
        <input
          type="text"
          className="mt-2 w-full border rounded px-3 py-2 bg-gray-100"
          placeholder="Estimated amount"
          value={estimatedAmountOut}
          readOnly
        />
      </div>

      <button className="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
        Swap
      </button>
    </div>
  );
}
