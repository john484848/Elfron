const std = @import("std");
const testing = std.testing;
var gpa= std.heap.GeneralPurposeAllocator(.{}){};
const allocator= gpa.allocator();
pub const dtype= enum {int, float, bool, string};
const cell= union {
    int: i64,
    float:f64,
    bool: bool,
    string: [*]u8,
};
const row= struct{
    Row:[*]cell,
    title:[*]u8,
    Size:u64,
};
pub const dataframe= struct{
    Rows:[*]row,
    Size:u64,
    ///pub fn addColumn() void{
    ///}
};
pub fn newdf() dataframe{
    return dataframe{.Rows=undefined, .Size=0};
}
test "basic add functionality" {
    var df1= newdf();
    try testing.expect(df1.Size==0);
}
