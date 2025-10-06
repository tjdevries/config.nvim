require("luasnip.session.snippet_collection").clear_snippets "go"

local ls = require "luasnip"

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

local make_cheat_code = function(str)
  return t(vim.split(str, "\n"))
end

ls.add_snippets("go", {
  s(
    "__decode",
    make_cheat_code [[
func DecodeMessage(msg []byte) (string, []byte, error) {
	header, content, found := bytes.Cut(msg, []byte("\r\n\r\n"))
	if !found {
		return "", nil, errors.New("no header found")
	}

	contentLength, err := strconv.Atoi(string(header[len("Content-Length: "):]))
	if err != nil {
		return "", nil, err
	}

	if len(content) < contentLength {
		return "", nil, errors.New("content too short")
	}

	var decoded Message
	err = json.Unmarshal(content, &decoded)
	if err != nil {
		return "", nil, err
	}

	return decoded.Method, content[:contentLength], nil
} ]]
  ),
  s(
    "__split_interface",
    make_cheat_code [[
func MessageSplit(msg []byte, atEOF bool) (advance int, token []byte, err error) {
}
]]
  ),
  s(
    "__split",
    make_cheat_code [[
func MessageSplit(msg []byte, atEOF bool) (advance int, token []byte, err error) {
	header, content, found := bytes.Cut(msg, []byte("\r\n\r\n"))
	if !found {
		return 0, nil, nil
	}

	contentLength, err := strconv.Atoi(string(header[len("Content-Length: "):]))
	if err != nil {
		return 0, nil, nil
	}

	if len(content) < contentLength {
		return 0, nil, nil
	}

	return len(header) + 4 + contentLength, msg[:len(header)+4+contentLength], nil
}
]]
  ),
  s(
    "__initialize",
    make_cheat_code [[
type InitializeRequest struct {
	Message
	Params InitializeParams `json:"params"`
}

type InitializeParams struct {
	ClientInfo struct {
		Name    string `json:"name"`
		Version string `json:"version"`
	} `json:"clientInfo"`
}

type InitializeResult struct {
	Message
	Result InitializeResultValues `json:"result"`
}

type InitializeResultValues struct {
	Capabilities ServerCapabilities `json:"capabilities"`
}]]
  ),

  s(
    "__write",
    make_cheat_code [[
func writeResponse(response any) {
	encoded := EncodeMessage(response)
	logger.Printf("Sending response: %s", encoded)
	io.WriteString(os.Stdout, encoded)
} ]]
  ),
  s(
    "__respond_initialize",
    make_cheat_code [[
		case "initialize":
			var req InitializeRequest
			err = json.Unmarshal(content, &req)
			if err != nil {
				panic(err)
			}

			logger.Printf("Initialize request: %s (btw), %s", req.Params.ClientInfo.Name, req.Params.ClientInfo.Version)

			response := InitializeResult{
				Message: Message{
					ID:  req.ID,
					RPC: "2.0",
				},
				Result: InitializeResultValues{
					Capabilities: ServerCapabilities{
						TextDocumentSync:   1,
						DefinitionProvider: true,
					},
				},
			}
			writeResponse(response)
]]
  ),
  s(
    "__scanner",
    make_cheat_code [[
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(MessageSplit)

	for scanner.Scan() {
		msg := scanner.Bytes()
    }
]]
  ),
})
