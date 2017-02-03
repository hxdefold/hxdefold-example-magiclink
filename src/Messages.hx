import defold.types.Message;

class Messages {
    public static var StartGame(default,never) = new Message<Void>("start_game");
    public static var NextLevel(default,never) = new Message<Void>("next_level");
    public static var RestartLevel(default,never) = new Message<Void>("restart_level");
    public static var ToMainMenu(default,never) = new Message<Void>("to_main_menu");
    public static var Hide(default,never) = new Message<Void>("hide");
    public static var Show(default,never) = new Message<Void>("show");
    public static var SetDropCounter(default,never) = new Message<{drops:Int}>("set_drop_counter");
    public static var Drop(default,never) = new Message<Void>("drop");
}
