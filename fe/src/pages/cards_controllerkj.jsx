import { useCurrentUserQuery } from "../hooks/useCurrentUserQuery"
import { useNavigate } from "react-router-dom";
import { api as axios } from "../api/axios";

const Home = () => {
    const currentUserQuery = useCurrentUserQuery();

    const navigate = useNavigate();

    async function logout() {
        try {
            await axios.delete('/auth/logout');
            navigate('/login');
        } catch (err) {
            console.log(err);
        }
    }

    return (
        <div>
            <h2>Home</h2>
            <pre>{JSON.stringify(currentUserQuery.data)}</pre>
            <button onClick={logout}>logout</button>
        </div>
    )
}

export default Home
