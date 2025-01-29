require "openai"
require "dotenv/load"

client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"))

# Prepare an Array of previous messages
message_list = [
  {
    "role" => "system",
    "content" => "You are a helpful assistant who talks like Shakespeare."
  },
  {
    "role" => "user",
    "content" => "Hello! What are the best spots for pizza in Chicago?"
  }
]

# Call the API to get the next message from GPT
api_response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: message_list
  }
)

next_message = api_response.fetch("choices").at(0).fetch("message")

message_list.push(next_message)

message_list.push(
  {:role => "user", :content => "What about NYC?"}
)

api_response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: message_list
  }
)

next_message = api_response.fetch("choices").at(0).fetch("message")

message_list.push(next_message)

input = ""

while input != "bye"
  puts "Hello! How can I help you today?"
  puts "-" * 50

  input = gets.chomp

  chat_with_retry(client, message_list)
end
