package helloworld
import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)
dagger.#Plan & {
	actions: {
		_alpine: core.#Pull & {source: "alpine:3"}
		hello: core.#Exec & {
			input: _alpine.output
			args: ["echo", "hello, world!"]
			always: true
		}
	}
}