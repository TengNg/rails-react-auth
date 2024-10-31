import { createContext } from "react";
import { useCurrentUserQuery } from "../hooks/useCurrentUserQuery";

const CurrentUserContext = createContext({});

export const CurrentUserContextProvider = ({ children }) => {
    const currentUserQuery = useCurrentUserQuery();

    return (
        <CurrentUserContext.Provider value={currentUserQuery}>
            {children}
        </CurrentUserContext.Provider>
    )
}

export default CurrentUserContext;

