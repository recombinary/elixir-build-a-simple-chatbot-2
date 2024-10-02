defmodule Chatbot do
  @config %OpenAI.Config{api_key: ""}

  def start(_type, _args) do
    # Initialize messages with the system message
    system_message = %{role: "system", content: "You always respond 'OK, whatever'"}
    messages = [system_message]
    loop(messages)
  end

  defp loop(messages) do
    # Get input from the user
    IO.write("🦄 Me: ")
    user_input = IO.gets("") |> String.trim()

    # Create a message from the user input
    user_message = %{role: "user", content: user_input}
    messages = messages ++ [user_message]

    # Get a reply from the AI
    {:ok, completion} =
      OpenAI.chat_completion(
        [model: "gtp-4o", messages: messages],
        @config
      )

    %{choices: [%{"message" => assistant_message}]} = completion

    # Save the assistant message
    messages = messages ++ [assistant_message]

    # Print the AI's reply
    IO.puts("🤖 AI: #{assistant_message["content"]}")

    loop(messages)
  end
end
