<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\BaseController;
use Laravel\Socialite\Facades\Socialite;

class RegisterController extends BaseController
{
    /**
     * Register api
     *
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        // $validator = \Illuminate\Support\Facades\Validator::make($request->all(), [
        //     'name' => 'required',
        //     'email' => 'required|email',
        //     'password' => 'required',
        //     'c_password' => 'required|same:password',
        // ]);

        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users',
            'password' => 'required',
            'c_password' => 'required|same:password',
        ]);

        // if ($validator->fails()) {
        //     return $this->sendError('Validation Error.', $validator->errors());
        // }

        $input = $request->all();
        $input['password'] = bcrypt($input['password']);
        $user = User::create($input);
        // $success['token'] =  $user->createToken('MyApp')->plainTextToken;
        // $success['name'] =  $user->name;

        return $this->sendResponse(null, 'User register successfully.');
    }

    /**
     * Login api
     *
     * @return \Illuminate\Http\Response
     */
    // login not using a provider
    protected function requestToken(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
            'device_name' => 'required',
        ]);

        // getting user
        $user = User::where('email', $request->email)->first();

        // checking credentials
        if (!$user || !\Illuminate\Support\Facades\Hash::check($request->password, $user->password)) {
            throw \Illuminate\Validation\ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        // Returning response
        return response()->json($this->getUserAndToken($user, $request->device_name));
    }

    protected function requestTokenGoogle(Request $request)
    {
        // Getting the user from socialite using token from google
        $user = Socialite::driver('google')->stateless()->userFromToken($request->token);

        // Getting or creating user from db
        $userFromDb = User::firstOrCreate(
            ['email' => $user->email],
            [
                'email_verified_at' => now(),
                'name' => $user->name,
                'status' => true,
            ]
        );

        // Returning response
        return response()->json($this->getUserAndToken($userFromDb, $request->device_name));
    }


    protected function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return $this->sendResponse(null, 'Successful');
    }
}