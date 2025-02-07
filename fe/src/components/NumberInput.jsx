import { useState } from "react";

export default function NumberInput({ ref, min = 0, max = 100, step = 1, initialValue = 0 }) {
  const [inputValue, setInputValue] = useState(initialValue);

  const updateValue = (newValue) => {
    if (newValue < min || newValue > max) return;
    setInputValue(newValue);
  };

  const handleIncrement = () => updateValue(inputValue + step);
  const handleDecrement = () => updateValue(inputValue - step);

  const handleChange = (e) => {
    const val = Number(e.target.value);
    if (!isNaN(val)) updateValue(val);
  };

  const handleKeyDown = (e) => {
    if (e.key === "ArrowUp") handleIncrement();
    if (e.key === "ArrowDown") handleDecrement();
  };

  return (
    <div className="flex items-center border rounded-lg px-2 py-1 w-48 bg-white shadow-sm">
      <button
        onClick={handleDecrement}
        className="p-2 hover:bg-gray-100 rounded-lg disabled:opacity-50"
        disabled={inputValue <= min}
      >
        -
      </button>
      <input
        ref={ref}
        type="number"
        className="mx-2 w-full text-center outline-none bg-transparent"
        value={inputValue}
        onChange={handleChange}
        onKeyDown={handleKeyDown}
      />
      <button
        onClick={handleIncrement}
        className="p-2 hover:bg-gray-100 rounded-lg disabled:opacity-50"
        disabled={inputValue >= max}
      >
        +
      </button>
    </div>
  );
}

