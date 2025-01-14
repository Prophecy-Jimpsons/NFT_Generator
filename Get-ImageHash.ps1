function Get-ImageHash {
    param ([string]$ImagePath)
    
    Add-Type -AssemblyName System.Drawing
    $image = [System.Drawing.Image]::FromFile($ImagePath)
    $bitmap = New-Object System.Drawing.Bitmap($image)
    
    # Convert to same format as Python
    $rect = New-Object System.Drawing.Rectangle(0, 0, $bitmap.Width, $bitmap.Height)
    $bitmapData = $bitmap.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, 
        [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    
    # Get raw bytes
    $bytes = New-Object byte[] ($bitmapData.Stride * $bitmap.Height)
    [System.Runtime.InteropServices.Marshal]::Copy($bitmapData.Scan0, $bytes, 0, $bytes.Length)
    
    # Calculate hash
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $hash = [BitConverter]::ToString($sha256.ComputeHash($bytes)).Replace("-", "").ToLower()
    
    # Cleanup
    $bitmap.UnlockBits($bitmapData)
    $bitmap.Dispose()
    $image.Dispose()
    
    Write-Host "Image Hash: $hash"
    return $hash
}

# Execute if run as script
if ($args.Count -gt 0) {
    Get-ImageHash -ImagePath $args[0]
}
else {
    Write-Host "Please provide an image path"
}
