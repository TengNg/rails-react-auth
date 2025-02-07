import { useState } from "react";

export default function SelectInput({ options, selectedOption, setSelectedOption }) {
  const [openSelectOptions, setOpenSelectOptions] = useState(false);

  return (
    <div className="relative w-[300px] ">
      <div
        className="flex justify-between w-full border-[1px] border-gray-600 p-4"
        onClick={() => {
          console.log("clicked");
          setOpenSelectOptions(prev => !prev)
        }}
      >
        <div>
          {selectedOption.label}
        </div>
        <div>
          caret
        </div>
      </div>

      {
        openSelectOptions &&
        <div className="absolute w-full h-fit top-[110%] right-0 border-[1px] border-gray-400">
          {
            options.map((option, index) => {
              return (
                <div
                  className="h-[50px] p-4"
                  onClick={() => {
                    setSelectedOption(option)
                    setOpenSelectOptions(false)
                  }}
                  key={index}
                >
                  {option.label}
                </div>
              )
            })
          }
        </div>
      }

    </div>
  )
}

