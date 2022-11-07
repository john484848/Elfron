const std = @import("std");
const testing = std.testing;
//var gpa= std.heap.GeneralPurposeAllocator(.{}){};
const allocator= std.heap.page_allocator;
//gpa.allocator();
pub const Dtype= enum {int, float, bool, string};
const Cell= union(Dtype) {
    int: i64,
    float:f64,
    bool: bool,
    string: []const u8,
};
const Column= struct{
    Row:[]Cell=undefined,
    title:[]const u8,
    size:u64=undefined,
    usage:u64=0,
    ctype:Dtype=Dtype.int,
};
pub const DataFrame= struct{
    Rows:std.StringHashMap(Column),
    size:u64,
    pub fn addColumn(self: *DataFrame,ctype:Dtype, title: []const u8) void{
        self.size+=1;
        var basic_union:Cell=undefined;
        switch(ctype){
            .int => {basic_union=Cell{.int=7};},
            .float =>{basic_union=Cell{.float=7};},
            .bool => {basic_union=Cell{.bool=true};},
            .string => {basic_union=Cell{.string="HI"};},
        }
        var nc= newcolumn();
        self.Rows.put(title, nc) catch @panic("Hash map failed");
        std.debug.print("Type:{}\n",.{ctype});
        std.debug.print("Type Union: {}\n",.{basic_union});
        std.debug.print("Type Union: {s}\n",.{title});

    }
};
pub fn newdf() DataFrame{
    return DataFrame{.Rows=std.StringHashMap(Column).init(allocator), .size=0};
}
fn newcolumn() Column{
    var nc:Column=Column{.title="HI"};
    nc.Row = allocator.alloc(Cell, 20) catch undefined;
    defer allocator.free(nc.Row);
    //expect(memory.len == 100);
    //var t= try allocator.alloc(u8,5);
    nc.Row[0]= Cell{.int=7};
    nc.Row[1]= Cell{.string="HI"};
    std.debug.print("{}\n", .{@})
    std.debug.print("{}\n",.{nc});
    return nc;

}
pub fn main() void{ 
    //var C:Column=
    //newcolumn();
    //std.debug.print("{}\n",.{C});
   var df1:DataFrame= newdf();
   //var s:[]const u8 = "HI";
   df1.addColumn(Dtype.int,"HI");
   //df1.addColumn(Dtype.float,s);
}
test "basic add functionality" {
    //var df1:DataFrame = newdf();
    //var s: []const u8 = "HI";
    //try testing.expect(df1.size==0);
    //df1.addColumn(Dtype.int,s);
    //try testing.expect(df1.size==1);
}
const expect = std.testing.expect;

test "allocation" {

    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);

    try expect(memory.len == 100);
    try expect(@TypeOf(memory) == []u8);
}

