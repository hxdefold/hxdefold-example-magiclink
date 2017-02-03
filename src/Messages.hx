import defold.types.Message;

class Messages {
    public static var NextLevel(default,never) = new Message<Void>("next_level");
    public static var Hide(default,never) = new Message<Void>("hide");
    public static var Show(default,never) = new Message<Void>("show");
}
