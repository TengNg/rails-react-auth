import { Outlet, useNavigate } from "react-router-dom";
import { useQuery } from '@tanstack/react-query'
import { fetchAdminTest } from "../api/adminApi";

const Admin = () => {
    const testQuery = useQuery({
        queryKey: ['admin-test'],
        queryFn: () => fetchAdminTest(),
        enabled: false,
    });

    const navigate = useNavigate();

    function test() {
        testQuery.refetch();
    };

    function back() {
        navigate(-1);
    };

    return (
        <div>
            <h2>Admin</h2>
            <button onClick={test}>test</button>
            <button onClick={back}>back</button>
            <Outlet />
        </div>
    )
}

export default Admin
