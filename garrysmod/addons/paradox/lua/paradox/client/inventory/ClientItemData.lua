ITEM_DATA = {}

net.Receive("P_SetItemData", function(_, _)
    local item = net.ReadItem()
    ITEM_DATA[item.uuid:toString()] = item
end)

net.Receive("P_ClearItemData", function(_, _)
    ITEM_DATA = {}
end)