
using Gtk;

public class HelloWorldApp : Gtk.Application {
	public HelloWorldApp() {
		Object(application_id: "com.example.HelloWorldApp");
	}

	protected override void activate() {
		var window = new ApplicationWindow(this);
		window.title = "Hello, world!";
		window.default_height = 400;
		window.default_width = 600;

		var button = new Button.with_label("Click me");
		button.clicked.connect(() => {
			button.label = "Hello world";
		});

		window.add(button);
		window.show_all();
	}

	public static int main(string[] args) {
		var app = new HelloWorldApp();
		return app.run(args);
	}
}