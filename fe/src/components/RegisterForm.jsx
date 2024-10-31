import { useRef } from 'react';
import { api as axios } from '../api/axios';
import { useNavigate } from 'react-router-dom';

function RegisterForm() {
    const usernameInputRef = useRef(null);
    const passwordInputRef = useRef(null);

    const navigate = useNavigate();

    async function signUp(e) {
        e.preventDefault();
        try {
            const reqBody = JSON.stringify({
                auth: {
                    username: usernameInputRef.current.value,
                    password: passwordInputRef.current.value
                }
            });
            await axios.post('/auth/register', reqBody);
            navigate('/');
        } catch (error) {
            console.log(error);
        }
    }

    return <form
        onSubmit={signUp}
        className='border-[2px] border-red-500'
    >
        <label>
            Username
            <input ref={usernameInputRef} type="text" name="text" />
        </label>

        <br />

        <label>
            Password
            <input ref={passwordInputRef} type="password" name="password" />
        </label>

        <br />

        <button type="submit">Submit</button>
        <button type="button" onClick={() => navigate('/login')}>Login</button>
    </form>
}

export default RegisterForm;
