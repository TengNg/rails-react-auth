import { useRef, useState } from 'react';
import { api as axios } from '../api/axios';
import { useNavigate } from 'react-router-dom';

function LoginForm() {
    const usernameInputRef = useRef(null);
    const passwordInputRef = useRef(null);
    const [errMsg, setErrMsg] = useState("");

    const navigate = useNavigate();

    async function login(e) {
        e.preventDefault();
        try {
            const reqBody = JSON.stringify({
                auth: {
                    username: usernameInputRef.current.value,
                    password: passwordInputRef.current.value
                }
            });
            await axios.post('/auth/login', reqBody);
            navigate('/');
        } catch (error) {
            setErrMsg(error.response?.data?.message || "Failed to login");
        }
    }

    return <form
        onSubmit={login}
        className='border-[2px] border-red-500'
    >
        <label>
            Username
            <input ref={usernameInputRef} type="text" name="text" autoComplete="false" />
        </label>

        <br />

        <label>
            Password
            <input ref={passwordInputRef} type="password" name="password" />
        </label>

        <br />

        <button type="submit">Submit</button>
        <button type="button" onClick={() => navigate('/register')}>Register</button>

        <p className="text-red-500">{errMsg}</p>
    </form>
}

export default LoginForm;
