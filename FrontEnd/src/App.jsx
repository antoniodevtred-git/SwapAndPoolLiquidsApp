import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import SwapPage from "./pages/SwapPage";
import PoolLiquidityPage from "./pages/PoolLiquidityPage";

export default function App() {
  return (
    <Router>
      <div className="p-6">
        <h1 className="text-3xl font-bold mb-4">Swap & Pool App</h1>
        <nav className="mb-6">
          <Link to="/" className="mr-4 text-blue-600">Swap</Link>
          <Link to="/pool" className="text-blue-600">Add Liquidity</Link>
        </nav>

        <Routes>
          <Route path="/" element={<SwapPage />} />
          <Route path="/pool" element={<PoolLiquidityPage />} />
        </Routes>
      </div>
    </Router>
  );
}
