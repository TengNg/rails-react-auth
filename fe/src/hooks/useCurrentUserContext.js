import { useContext } from "react";
import CurrentUserContext from "../context/CurrentUserContext";

const useCurrentUserContext = () => {
    return useContext(CurrentUserContext);
}

export default useCurrentUserContext;
