/* DummyLinuxOSLog

This file creates a dummy os_log method for Linux, that will call NSLog. (I’m
aware NSLog calls os_log on Apple’s platforms, but calling os_log directly gives
more options, like defining a log level, and much more.)
Note: os_log does not use the exact same format as NSLog. The dummy os_log
method tries and convert from the os_log format to the NSLog one, but some edge
cases are not supported.

On Linux, String is not CVarArg compliant, so this file also provides an
NSLogString method to use as a replacement for os_log when the logged entry has
a format expecting a String. The NSLogString is safe to use with user-defined
text inserted in the string (it does not use formats).
Note: As the function uses NSLog and simply _converts_ the inputed string into a
formatless one, I _might_ have missed some edge cases which might still make the
app crash because of missing formats.

Full example of a log compatible with all Swift-supported platforms:
	/* Module imports */
	#if canImport(os)
		import os.log
	#elseif canImport(DummyLinuxOSLog)
		import DummyLinuxOSLog
	#endif

	/* Actual log code */
	#if canImport(os)
		if #available(OSX 10.12, tvOS 10.0, iOS 10.0, watchOS 3.0, *) {logObject.flatMap{ os_log("Logging this string: %@", log: $0, type: .error, theString) }}
		else                                                          {NSLog("***** Logging this string: %@", theString)}
	#else
		NSLogString("***** Logging this string: \(theString)")
	#endif


How delightful! */

import Foundation



#if !canImport(os)

public typealias OSLog = Void?

public enum OSLogType {
	case `default`
	case info
	case debug
	case error
	case fault
}

public func os_log(_ message: StaticString, dso: UnsafeRawPointer? = #dsohandle, log: OSLog = (), type: OSLogType = .default, _ args: CVarArg...) {
	guard log != nil else {return}
	
	let messageString = message.withUTF8Buffer{ buffer -> String in
		String(decoding: buffer, as: UTF8.self)
	}
	let regex = try! NSRegularExpression(pattern: "%\\{.*\\}", options: []) /* Note: "Hello %%{world}!" fails. Not the end of the world… */
	let fullRange = NSRange(messageString.startIndex..<messageString.endIndex, in: messageString)
	let nonOSLogMessageString = regex.stringByReplacingMatches(in: messageString, options: [], range: fullRange, withTemplate: "%")
	withVaList(args, { vaListPtr in
		NSLogv(nonOSLogMessageString, vaListPtr)
	})
}

public func NSLogString(_ str: String) {
	NSLog(str.replacingOccurrences(of: "%", with: "%%"))
}

#endif
