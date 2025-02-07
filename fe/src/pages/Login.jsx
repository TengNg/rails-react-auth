import { useState } from "react"
import LoginForm from "../components/LoginForm"
import SelectInput from "../components/SelectInput"
import NumberInput from "../components/NumberInput"
import { useRef } from "react"

const options = [
  {
    label: "option 1",
    value: "1"
  },
  {
    label: "option 2",
    value: "2"
  },
  {
    label: "option 3",
    value: "3"
  },
  {
    label: "option 4",
    value: "4"
  }
]

const Login = () => {
  const [value, setValue] = useState(options[0]);

  const numberInput1 = useRef(null);
  const numberInput2 = useRef(null);

  return (
    <div>
      <h2>Login</h2>
      <LoginForm />

      <div className="my-8"></div>

      <SelectInput options={options} selectedOption={value} setSelectedOption={setValue} />

      <div className="my-8"></div>

      <NumberInput
        ref={numberInput1}
        min={0} max={50} step={1} initialValue={10}
      />

      <div className="my-8"></div>

      <NumberInput
        ref={numberInput2}
        min={0} max={1} step={0.25} initialValue={0.5}
      />

      <div className="my-8"></div>

      <button
        onClick={() => {
          if (numberInput1.current) {
            console.log(numberInput1.current.value);
          }
        }}
      >test 1</button>

      <button
        onClick={() => {
          if (numberInput2.current) {
            console.log(numberInput2.current.value);
          }
        }}
      >test 2</button>

    </div>
  )
}

export default Login
