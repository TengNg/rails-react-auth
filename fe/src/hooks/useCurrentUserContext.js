import CurrentUserContext from "../context/CurrentUserContext";
import { use } from "react";

const useCurrentUserContext = () => {
    return use(CurrentUserContext);
}

export default useCurrentUserContext;
