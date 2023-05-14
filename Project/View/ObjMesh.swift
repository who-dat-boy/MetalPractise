//
//  objMesh.swift
//  MetalPractise
//
//  Created by Arthur ? on 14.04.2023.
//
import MetalKit

class ObjMesh {
    
    let modelIOMesh: MDLMesh
    let metalMesh: MTKMesh
    
    init(device: MTLDevice, allocator: MTKMeshBufferAllocator, filename: String) {
        guard let meshURL = Bundle.main.url(forResource: filename, withExtension: "obj") else {
            fatalError()
        }
        let vertexDescriptor = MTLVertexDescriptor()
        
        var offset: Int = 0
        
        //position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = offset
        vertexDescriptor.attributes[0].bufferIndex = 0
        offset += MemoryLayout<SIMD3<Float>>.stride
        //texCoord
        vertexDescriptor.attributes[1].format = .float2
        vertexDescriptor.attributes[1].offset = offset
        vertexDescriptor.attributes[1].bufferIndex = 0
        offset += MemoryLayout<SIMD2<Float>>.stride
        //normal
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].offset = offset
        vertexDescriptor.attributes[2].bufferIndex = 0
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        vertexDescriptor.layouts[0].stride = offset
        
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        (meshDescriptor.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate
        (meshDescriptor.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeNormal
        let asset = MDLAsset(url: meshURL,
                             vertexDescriptor: meshDescriptor,
                             bufferAllocator: allocator)
        self.modelIOMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        do {
            metalMesh = try MTKMesh(mesh: self.modelIOMesh, device: device)
        } catch {
            fatalError("couldn't load mesh")
        }
    }
}
