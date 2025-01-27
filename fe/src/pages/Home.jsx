import { Outlet, useNavigate } from "react-router-dom";
import { api as axios } from "../api/axios";
import useCurrentUserContext from "../hooks/useCurrentUserContext";
import { useQueryClient } from "@tanstack/react-query";

const Home = () => {
    const queryClient = useQueryClient();
    const currentUserQuery = useCurrentUserContext();

    const navigate = useNavigate();

    async function logout() {
        try {
            await axios.delete('/logout');
            queryClient.removeQueries({ queryKey: ['me'], exact: true });
            navigate('/login');
        } catch (err) {
            console.log(err);
        }
    }

    async function logoutOfAllDevices() {
        try {
            await axios.delete('/logout_of_all_devices');
            queryClient.removeQueries({ queryKey: ['me'], exact: true });
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

            {
                currentUserQuery.data.roles.some(role => role === 'admin') &&
                <button onClick={() => navigate('/admin/test')}>admin</button>
            }

            <button onClick={() => navigate('/cards')}>cards</button>
            <button onClick={logout}>logout</button>
            <button onClick={logoutOfAllDevices}>logout of all devices</button>
        </div>
    )
}

export default Home
