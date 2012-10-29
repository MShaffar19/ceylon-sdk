import ceylon.net.httpd { HttpRequest, WebEndpointConfig }
import io.undertow.server { HttpServerExchange }
import java.util { Deque, JMap = Map }
import java.lang { JString = String }
import ceylon.io { SocketAddress }

shared class HttpRequestImpl(HttpServerExchange exchange) satisfies HttpRequest {
	
	variable WebEndpointConfig? endpointConfig := null;
		
	shared actual String? header(String name) {
		return exchange.requestHeaders.getFirst(name);
	}

	shared actual String[] headers(String name) {
		Deque<JString> headers = exchange.requestHeaders.get(name);
		SequenceBuilder<String> sequenceBuilder = SequenceBuilder<String>();

		value it = headers.iterator();
		while (exists header = it.next()) {
			sequenceBuilder.append(header.string);
		}
		
		return sequenceBuilder.sequence;
	}

	shared actual String? parameter(String name) {
		value params = parameters(name);
		if (nonempty params) {
			return params.first;
		} else {
			return null;
		}
	}

	shared actual String[]|Empty parameters(String name) {
		SequenceBuilder<String> sequenceBuilder = SequenceBuilder<String>();

		value paramName = JString(name);
		JMap<JString,Deque<JString>> qp = exchange.queryParameters;
		
		if (qp.containsKey(paramName)) {
			Deque<JString> params = qp.get(paramName);
			value it = params.iterator();
			while (it.hasNext()) {
				value param = it.next(); 
				sequenceBuilder.append(param.string);
			}
		}
		return sequenceBuilder.sequence;
	}

	shared actual String uri() {
		return exchange.requestURI;
	}
	
	shared actual String path() {
		return exchange.requestPath;
	}
	
	shared actual String relativePath() {
		String requestPath = path();
		if (exists e = endpointConfig) {
			String mappingPath = e.path;
			return requestPath[mappingPath.size .. (requestPath.size - 1 )];
		}
		return requestPath;
	}
	
	shared actual SocketAddress destinationAddress() {
		value address = exchange.destinationAddress;
		return SocketAddress(address.hostString, address.port);
	}
	
	shared actual String method() {
		return exchange.requestMethod;
	}
	
	shared actual String queryString() {
		return exchange.queryString;
	}
	
	shared actual String scheme() {
		return exchange.requestScheme;
	}
	
	shared void webEndpointConfig(WebEndpointConfig webEndpointConfig) {
		endpointConfig := webEndpointConfig;
	}
	
	shared actual SocketAddress sourceAddress() {
		value address = exchange.sourceAddress;
		return SocketAddress(address.hostString, address.port);
	}

	
}