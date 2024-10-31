import { useCurrentUserQuery } from "../hooks/useCurrentUserQuery"
import { Outlet, useNavigate } from "react-router-dom";
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

    async function logoutOfAllDevices() {
        try {
            await axios.delete('/auth/logout_of_all_devices');
            navigate('/login');
        } catch (err) {
            console.log(err);
        }
    }

    return (
        <div>
            <h2>Home</h2>
            <pre>{JSON.stringify(currentUserQuery.data)}</pre>
            <Outlet />
            <button onClick={() => navigate('/cards')}>cards</button>
            <button onClick={logout}>logout</button>
            <button onClick={logoutOfAllDevices}>logout of all devices</button>
        </div>
    )
}

export default Home
