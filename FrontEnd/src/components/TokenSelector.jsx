// src/components/TokenSelector.jsx
import { useEffect, useState } from "react";

export default function TokenSelector({ selectedToken, onChange }) {
  const [tokens, setTokens] = useState([]);

  useEffect(() => {
    const fetchTokens = async () => {
      const res = await fetch("https://tokens.uniswap.org/");
      const data = await res.json();

      // 🔁 eliminar duplicados por address
      const uniqueTokens = Array.from(
        new Map(
          data.tokens.map((t) => [t.address.toLowerCase(), t])
        ).values()
      );

      setTokens(uniqueTokens);
    };

    fetchTokens();
  }, []);

  return (
    <select
      className="w-full border rounded px-3 py-2"
      value={selectedToken?.address || ""}
      onChange={(e) => {
        const token = tokens.find(
          (t) => t.address === e.target.value
        );
        onChange(token || null); // ✅ AQUÍ ESTÁ LA CLAVE
      }}
    >
      <option value="">Selecciona un token</option>

      {tokens.map((token) => (
        <option key={token.address} value={token.address}>
          {token.symbol}
        </option>
      ))}
    </select>
  );
}
