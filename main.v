import json
import syou.picoev
import syou.picohttpparser as hp

struct Message {
	message string
}

[inline]
fn json_response() string {
	msg := Message{
		message: 'Hello, World!'
	}
	return json.encode(msg)
}

[inline]
fn hello_response() string {
	return 'Hello, World!'
}

pub fn callback(req hp.Request, res mut hp.Response) {
	if hp.cmpn(req.method, 'GET ', 4) {
		if hp.cmp(req.path, '/t') {
			res.http_ok_plain(hello_response())
		}
		else if hp.cmp(req.path, '/j') {
			res.http_ok_json(json_response())
		}
		else {
			res.http_404()
		}
	}
	else {
		res.http_405()
	}
}

pub fn main() {
	picoev.new(8088, &callback).serve()
}
