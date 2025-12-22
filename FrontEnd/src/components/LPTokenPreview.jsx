// src/components/LPTokenPreview.jsx

export default function LPTokenPreview({ tokenA, tokenB, amountA, amountB, lpTokens }) {
    if (!tokenA || !tokenB || !lpTokens) {
        return (
          <p className="text-sm text-gray-500 mb-4 italic">
            Selecciona tokens y cantidades para ver el LP preview...
          </p>
        );
      }
    return (
      <div className="mt-6 p-4 border rounded shadow bg-gray-50">
        <h3 className="text-lg font-semibold mb-4 text-center">Liquidity Preview</h3>
  
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center space-x-2">
            <img src={tokenA.logoURI} alt={tokenA.symbol} className="w-6 h-6 rounded-full" />
            <span className="font-medium">{tokenA.symbol}</span>
          </div>
          <span>{amountA}</span>
        </div>
  
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center space-x-2">
            <img src={tokenB.logoURI} alt={tokenB.symbol} className="w-6 h-6 rounded-full" />
            <span className="font-medium">{tokenB.symbol}</span>
          </div>
          <span>{amountB}</span>
        </div>
  
        <div className="text-center mt-4 text-green-700 font-semibold">
          Estimated LP Tokens: {lpTokens}
        </div>
      </div>
    );
    console.log("🧪 Preview tokens:", tokenA?.symbol, tokenB?.symbol, "LP:", lpTokens);

  }
  