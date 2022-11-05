const std = @import("std");
const testing = std.testing;
var gpa= std.heap.GeneralPurposeAllocator(.{}){};
const allocator= gpa.allocator();
pub const dtype= enum {int, float, bool, string};
const cell= union(dtype) {
    int: i64,
    float:f64,
    bool: bool,
    string: []u8,
};
const column= struct{
    Row:[]cell,
    title:[]u8,
    size:u64,
};
pub const DataFrame= struct{
    Rows:std.StringHashMap(column),
    size:u64,
    pub fn addColumn(self: *DataFrame,ctype:dtype, title: []const u8) void{
        self.size+=1;
        var basic_union:cell=undefined;
        switch(ctype){
            .int => {basic_union=cell{.int=7};},
            .float =>{basic_union=cell{.float=7};}, 
            else => {unreachable;},
        }

        std.debug.print("Type:{}\n",.{ctype});
        std.debug.print("Type Union: {}\n",.{basic_union});
        std.debug.print("Type Union: {s}\n",.{title});

    }
};
pub fn newdf() DataFrame{
    return DataFrame{.Rows=std.StringHashMap(column).init(allocator), .size=0};
}
pub fn main() void{ 
   var df1= newdf();
   var s="HI";
   df1.addColumn(dtype.int,s);
   df1.addColumn(dtype.float,s);
}
test "basic add functionality" {
    var df1= newdf();
    var s="HI";
    try testing.expect(df1.size==0);
    df1.addColumn(dtype.int,s);
    try testing.expect(df1.size==1);
}
