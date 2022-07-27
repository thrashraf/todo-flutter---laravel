<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreTodoRequest;
use App\Http\Requests\UpdateTodoRequest;
use App\Models\Todo;
use App\Models\User;
use Illuminate\Support\Facades\Validator;

class TodoController extends BaseController
{
    /**
     * Display todo by user id
     *
     * @return \Illuminate\Http\Response
     */
    public function index(User $author)
    {
        return ['todos' => $author->todos];
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \App\Http\Requests\StoreTodoRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreTodoRequest $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'task' => 'required',
                'user_id' => 'required'
            ]
        );

        if ($validator->fails()) {
            return $this->sendError("todos can't be null");
        }
        $input = $request->all();
        $newTodo = Todo::create($input);

        return $this->sendResponse($newTodo, 'Successful create todos!');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Todo  $todo
     * @return \Illuminate\Http\Response
     */

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateTodoRequest  $request
     * @param  \App\Models\Todo  $todo
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateTodoRequest $request, $id)
    {

        $validator = Validator::make(
            $request->all(),
            [
                'task' => 'required',
                'isCheck' => 'required',
            ]
        );

        if ($validator->fails()) {
            return $this->sendError("something went wrong");
        }

        $updatedRow = Todo::where("id", $id)->update(["task" => $request["task"], "isCheck" => $request["isCheck"]]);

        return $this->sendResponse($updatedRow, 'Successful update!');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Todo  $todo
     * @return \Illuminate\Http\Response
     */
    public function destroy(Todo $todo, $id)
    {
        $todo->destroy($id);
        return $this->sendResponse(null, 'Successful delete!');
    }
}