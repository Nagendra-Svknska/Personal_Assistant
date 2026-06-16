import streamlit as st
from ollama import chat

st.set_page_config(page_title="NutriStart Assistant",layout="wide")
st.title("🚀 NutriStart Assistant")
st.markdown("Your local AI assistant powered by Ollama + Qwen")

# Session memory
if "messages" not in st.session_state:
    st.session_state.messages = []

# Show chat history
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# User input
prompt = st.chat_input("Ask me anything...")

if prompt:

    st.session_state.messages.append({"role": "user","content": prompt})

    with st.chat_message("user"):
        st.markdown(prompt)

    with st.chat_message("assistant"):

        with st.spinner("Thinking..."):

            response = chat(
                model="qwen2.5-coder:7b",
                messages=[
                    {
                        "role": m["role"],
                        "content": m["content"]
                    }
                    for m in st.session_state.messages
                ]
            )

            answer = response["message"]["content"]

            st.markdown(answer)

    st.session_state.messages.append({"role": "assistant","content": answer})